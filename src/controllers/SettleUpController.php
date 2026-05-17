<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/GroupsRepository.php';
require_once __DIR__ . '/../repositories/BalancesRepository.php';
require_once __DIR__ . '/../repositories/PaymentsRepository.php';
require_once __DIR__ . '/../models/Payment.php';

class SettleUpController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): SettleUpController {
        if (is_null(self::$instance)) {
            self::$instance = new SettleUpController();
        }

        return self::$instance;
    }

    public function index($groupId): void {
        $this->requireAuth();
        $userId  = (int)$_SESSION['user_id'];
        $groupId = (int)$groupId;

        $groupRepo = new GroupsRepository();
        $group     = $groupRepo->getGroupById($groupId);

        if (!$group || !$groupRepo->isMember($groupId, $userId)) {
            include 'public/views/404.html';
            return;
        }

        $suggestions = (new BalancesRepository())->getSettlementSuggestions($groupId);

        $this->render('settle-up', [
            'pageTitle'   => 'Settle Up — MoneyPLS',
            'activePage'  => 'groups',
            'group'       => $group,
            'suggestions' => $suggestions,
            'userId'      => $userId,
        ]);
    }

    public function pay($groupId): void {
        $this->requireAuth();
        $userId  = (int)$_SESSION['user_id'];
        $groupId = (int)$groupId;

        $groupRepo = new GroupsRepository();
        $group     = $groupRepo->getGroupById($groupId);

        if (!$group || !$groupRepo->isMember($groupId, $userId)) {
            include 'public/views/404.html';
            return;
        }

        if (!$this->isPost()) {
            $this->redirect("groups/{$groupId}/settle");
            return;
        }

        $toUserId = (int)($_POST['to_user_id'] ?? 0);
        $amount   = (float)($_POST['amount'] ?? 0);
        $note     = trim($_POST['note'] ?? '');

        $payment = new Payment($groupId, $userId, $toUserId, $amount, $note ?: null);

        if ($payment->validate()) {
            (new PaymentsRepository())->createPayment($payment);
        }

        $this->redirect("groups/{$groupId}/settle");
    }
}
