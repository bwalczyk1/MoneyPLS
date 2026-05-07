<?php

require_once 'Repository.php';

class BalancesRepository extends Repository {

    public function getUserBalance(int $userId): array {
        $conn = $this->database->connect();

        // Total paid by user across all groups
        $q = $conn->prepare("
            SELECT COALESCE(SUM(e.amount), 0)
            FROM expenses e
            JOIN group_members gm ON gm.group_id = e.group_id AND gm.user_id = :uid
            WHERE e.paid_by = :uid2
        ");
        $q->execute([':uid' => $userId, ':uid2' => $userId]);
        $totalPaid = (float)$q->fetchColumn();

        // Total owed by user (user's shares)
        $q = $conn->prepare("
            SELECT COALESCE(SUM(es.share_amount), 0)
            FROM expense_shares es
            WHERE es.user_id = :uid
        ");
        $q->bindParam(':uid', $userId, PDO::PARAM_INT);
        $q->execute();
        $totalShare = (float)$q->fetchColumn();

        // Payments sent by user
        $q = $conn->prepare("SELECT COALESCE(SUM(amount), 0) FROM payments WHERE from_user_id = :uid");
        $q->bindParam(':uid', $userId, PDO::PARAM_INT);
        $q->execute();
        $paymentsSent = (float)$q->fetchColumn();

        // Payments received by user
        $q = $conn->prepare("SELECT COALESCE(SUM(amount), 0) FROM payments WHERE to_user_id = :uid");
        $q->bindParam(':uid', $userId, PDO::PARAM_INT);
        $q->execute();
        $paymentsReceived = (float)$q->fetchColumn();

        // Net: positive = others owe you, negative = you owe others
        $net = ($totalPaid - $totalShare) + ($paymentsSent - $paymentsReceived);

        return [
            'total'          => round($net, 2),
            'owed_to_user'   => round(max($net, 0), 2),
            'user_owes'      => round(max(-$net, 0), 2),
        ];
    }

    public function getGroupBalances(int $groupId): array {
        $conn = $this->database->connect();

        $q = $conn->prepare("SELECT user_id FROM group_members WHERE group_id = :gid");
        $q->bindParam(':gid', $groupId, PDO::PARAM_INT);
        $q->execute();
        $memberIds = $q->fetchAll(PDO::FETCH_COLUMN);

        $balances = [];
        foreach ($memberIds as $uid) {
            $q = $conn->prepare("
                SELECT COALESCE(SUM(amount), 0) FROM expenses
                WHERE group_id = :gid AND paid_by = :uid
            ");
            $q->execute([':gid' => $groupId, ':uid' => $uid]);
            $paid = (float)$q->fetchColumn();

            $q = $conn->prepare("
                SELECT COALESCE(SUM(es.share_amount), 0)
                FROM expense_shares es
                JOIN expenses e ON e.id = es.expense_id
                WHERE e.group_id = :gid AND es.user_id = :uid
            ");
            $q->execute([':gid' => $groupId, ':uid' => $uid]);
            $share = (float)$q->fetchColumn();

            $q = $conn->prepare("SELECT COALESCE(SUM(amount), 0) FROM payments WHERE group_id = :gid AND from_user_id = :uid");
            $q->execute([':gid' => $groupId, ':uid' => $uid]);
            $sent = (float)$q->fetchColumn();

            $q = $conn->prepare("SELECT COALESCE(SUM(amount), 0) FROM payments WHERE group_id = :gid AND to_user_id = :uid");
            $q->execute([':gid' => $groupId, ':uid' => $uid]);
            $received = (float)$q->fetchColumn();

            $balances[$uid] = round(($paid - $share) + ($sent - $received), 2);
        }

        return $balances;
    }

    public function getSettlementSuggestions(int $groupId): array {
        $balances = $this->getGroupBalances($groupId);

        $conn = $this->database->connect();
        $q = $conn->prepare("SELECT u.id, u.username FROM users u JOIN group_members gm ON gm.user_id = u.id WHERE gm.group_id = :gid");
        $q->bindParam(':gid', $groupId, PDO::PARAM_INT);
        $q->execute();
        $names = $q->fetchAll(PDO::FETCH_KEY_PAIR);

        $creditors = [];
        $debtors = [];
        foreach ($balances as $uid => $net) {
            if ($net > 0.005)       $creditors[] = ['id' => $uid, 'amount' => $net];
            elseif ($net < -0.005)  $debtors[]   = ['id' => $uid, 'amount' => -$net];
        }

        usort($creditors, fn($a, $b) => $b['amount'] <=> $a['amount']);
        usort($debtors,   fn($a, $b) => $b['amount'] <=> $a['amount']);

        $suggestions = [];
        $i = 0; $j = 0;
        while ($i < count($creditors) && $j < count($debtors)) {
            $amount = min($creditors[$i]['amount'], $debtors[$j]['amount']);
            $suggestions[] = [
                'from_user_id'   => $debtors[$j]['id'],
                'to_user_id'     => $creditors[$i]['id'],
                'from_username'  => $names[$debtors[$j]['id']] ?? '',
                'to_username'    => $names[$creditors[$i]['id']] ?? '',
                'amount'         => round($amount, 2),
            ];
            $creditors[$i]['amount'] -= $amount;
            $debtors[$j]['amount']   -= $amount;
            if ($creditors[$i]['amount'] < 0.005) $i++;
            if ($debtors[$j]['amount']   < 0.005) $j++;
        }

        return $suggestions;
    }
}
