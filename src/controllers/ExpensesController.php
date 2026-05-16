<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/GroupsRepository.php';
require_once __DIR__ . '/../repositories/ExpensesRepository.php';
require_once __DIR__ . '/../models/Expense.php';

class ExpensesController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): ExpensesController {
        if (is_null(self::$instance)) {
            self::$instance = new ExpensesController();
        }
        return self::$instance;
    }

    public function create($groupId): void {
        $this->requireAuth();
        $userId  = (int)$_SESSION['user_id'];
        $groupId = (int)$groupId;

        $groupRepo = new GroupsRepository();
        $group     = $groupRepo->getGroupById($groupId);

        if (!$group || !$groupRepo->isMember($groupId, $userId)) {
            include 'public/views/404.html';
            return;
        }

        $members = $groupRepo->getMembersForGroup($groupId);

        if ($this->isGet()) {
            $this->render('expense-form', [
                'pageTitle'  => 'Add Expense — MoneyPLS',
                'activePage' => 'groups',
                'group'      => $group,
                'members'    => $members,
                'categories' => Expense::categories(),
                'userId'     => $userId,
            ]);
            return;
        }

        $description  = trim($_POST['description'] ?? '');
        $amount       = (float)($_POST['amount'] ?? 0);
        $category     = $_POST['category'] ?? 'general';
        $paidBy       = (int)($_POST['paid_by'] ?? $userId);
        $expenseDate  = $_POST['expense_date'] ?? date('Y-m-d');
        $splitType    = $_POST['split_type'] ?? 'equal';
        $splitBetween = array_map('intval', $_POST['split_between'] ?? array_column($members, 'id'));

        $expense = new Expense($groupId, $paidBy, $description, $category, $amount, $expenseDate);

        if (!$expense->validate() || empty($splitBetween)) {
            $errors = $expense->getErrors();
            if (empty($splitBetween)) {
                $errors['split_between'] = 'Select at least one person';
            }
            $this->render('expense-form', [
                'pageTitle'  => 'Add Expense — MoneyPLS',
                'activePage' => 'groups',
                'group'      => $group,
                'members'    => $members,
                'categories' => Expense::categories(),
                'userId'     => $userId,
                'errors'     => $errors,
                'old'        => $_POST,
            ]);
            return;
        }

        if ($splitType === 'equal') {
            $share = round($amount / count($splitBetween), 2);
            $shares = array_map(fn($uid) => ['user_id' => $uid, 'share_amount' => $share], $splitBetween);
        } else {
            $shares = [];
            foreach ($splitBetween as $uid) {
                $customAmount = (float)($_POST["custom_share_{$uid}"] ?? 0);
                $shares[] = ['user_id' => $uid, 'share_amount' => $customAmount];
            }

            $sharesSum = array_sum(array_column($shares, 'share_amount'));

            if (abs($sharesSum - $amount) > 0.01) {
                $this->render('expense-form', [
                    'pageTitle'  => 'Add Expense — MoneyPLS',
                    'activePage' => 'groups',
                    'group'      => $group,
                    'members'    => $members,
                    'categories' => Expense::categories(),
                    'userId'     => $userId,
                    'errors'     => ['split_between' => 'Custom shares must add up to the total amount'],
                    'old'        => $_POST,
                ]);

                return;
            }
        }

        (new ExpensesRepository())->createExpense($expense, $shares);
        $this->redirect("groups/{$groupId}");
    }
}
