<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/Expense.php';
require_once __DIR__ . '/../models/ExpenseShare.php';

class ExpensesRepository extends Repository {

    public function getExpensesForGroup(int $groupId): array {
        $query = $this->database->connect()->prepare("
            SELECT e.*, u.username AS paid_by_username
            FROM expenses e
            JOIN users u ON u.id = e.paid_by
            WHERE e.group_id = :group_id
            ORDER BY e.expense_date DESC, e.created_at DESC
        ");
        $query->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getExpenseById(int $id): ?Expense {
        $query = $this->database->connect()->prepare("SELECT * FROM expenses WHERE id = :id");
        $query->bindParam(':id', $id, PDO::PARAM_INT);
        $query->execute();
        $row = $query->fetch(PDO::FETCH_ASSOC);
        return $row ? Expense::fromArray($row) : null;
    }

    public function getSharesForExpense(int $expenseId): array {
        $query = $this->database->connect()->prepare("
            SELECT es.*, u.username FROM expense_shares es
            JOIN users u ON u.id = es.user_id
            WHERE es.expense_id = :expense_id
        ");
        $query->bindParam(':expense_id', $expenseId, PDO::PARAM_INT);
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function createExpense(Expense $expense, array $shares): int {
        $conn = $this->database->connect();
        $conn->beginTransaction();
        try {
            $q = $conn->prepare("
                INSERT INTO expenses (group_id, paid_by, description, category, amount, expense_date)
                VALUES (:group_id, :paid_by, :description, :category, :amount, :expense_date)
                RETURNING id
            ");
            $q->execute([
                ':group_id'    => $expense->groupId,
                ':paid_by'     => $expense->paidBy,
                ':description' => $expense->description,
                ':category'    => $expense->category,
                ':amount'      => $expense->amount,
                ':expense_date'=> $expense->expenseDate,
            ]);
            $expenseId = (int)$q->fetchColumn();

            $qs = $conn->prepare("
                INSERT INTO expense_shares (expense_id, user_id, share_amount)
                VALUES (:expense_id, :user_id, :share_amount)
            ");
            foreach ($shares as $share) {
                $qs->execute([
                    ':expense_id'  => $expenseId,
                    ':user_id'     => $share['user_id'],
                    ':share_amount'=> $share['share_amount'],
                ]);
            }

            $conn->commit();
            return $expenseId;
        } catch (Exception $e) {
            $conn->rollBack();
            throw $e;
        }
    }

    public function getRecentActivity(int $userId, int $limit = 50): array {
        $query = $this->database->connect()->prepare("
            SELECT
                'expense' AS type,
                e.id,
                e.description,
                e.amount,
                e.created_at,
                g.name AS group_name,
                g.id AS group_id,
                u.username AS actor
            FROM expenses e
            JOIN groups g ON g.id = e.group_id
            JOIN group_members gm ON gm.group_id = g.id AND gm.user_id = :uid1
            JOIN users u ON u.id = e.paid_by

            UNION ALL

            SELECT
                'payment' AS type,
                p.id,
                COALESCE(p.note, 'Settlement') AS description,
                p.amount,
                p.created_at,
                g.name AS group_name,
                g.id AS group_id,
                u.username AS actor
            FROM payments p
            JOIN groups g ON g.id = p.group_id
            JOIN group_members gm ON gm.group_id = g.id AND gm.user_id = :uid2
            JOIN users u ON u.id = p.from_user_id

            ORDER BY created_at DESC
            LIMIT :lim
        ");
        $query->bindParam(':uid1', $userId, PDO::PARAM_INT);
        $query->bindParam(':uid2', $userId, PDO::PARAM_INT);
        $query->bindParam(':lim', $limit, PDO::PARAM_INT);
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
}
