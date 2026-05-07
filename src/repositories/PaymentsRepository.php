<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/Payment.php';

class PaymentsRepository extends Repository {

    public function getPaymentsForGroup(int $groupId): array {
        $query = $this->database->connect()->prepare("
            SELECT p.*, uf.username AS from_username, ut.username AS to_username
            FROM payments p
            JOIN users uf ON uf.id = p.from_user_id
            JOIN users ut ON ut.id = p.to_user_id
            WHERE p.group_id = :group_id
            ORDER BY p.created_at DESC
        ");
        $query->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function createPayment(Payment $payment): int {
        $query = $this->database->connect()->prepare("
            INSERT INTO payments (group_id, from_user_id, to_user_id, amount, note)
            VALUES (:group_id, :from_user_id, :to_user_id, :amount, :note)
            RETURNING id
        ");
        $query->execute([
            ':group_id'     => $payment->groupId,
            ':from_user_id' => $payment->fromUserId,
            ':to_user_id'   => $payment->toUserId,
            ':amount'       => $payment->amount,
            ':note'         => $payment->note,
        ]);
        return (int)$query->fetchColumn();
    }
}
