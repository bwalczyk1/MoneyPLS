<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/GroupsRepository.php';
require_once __DIR__ . '/../repositories/BalancesRepository.php';

class DashboardController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): DashboardController {
        if (is_null(self::$instance)) {
            self::$instance = new DashboardController();
        }

        return self::$instance;
    }

    public function index($id = null): void {
        $this->requireAuth();
        $userId = (int)$_SESSION['user_id'];

        $groupRepo = new GroupsRepository();
        $groups    = $groupRepo->getGroupsForUser($userId);

        $groupsData = [];

        foreach (array_slice($groups, 0, 6) as $group) {
            $members  = $groupRepo->getMembersForGroup($group->id);
            $balances = (new BalancesRepository())->getGroupBalances($group->id);
            $userNet  = $balances[$userId] ?? 0;

            $groupsData[] = [
                'group'   => $group,
                'members' => $members,
                'userNet' => $userNet,
            ];
        }

        $balance = (new BalancesRepository())->getUserBalance($userId);

        $this->render('dashboard', [
            'pageTitle'  => 'Dashboard — MoneyPLS',
            'activePage' => 'dashboard',
            'balance'    => $balance,
            'groupsData' => $groupsData,
            'username'   => $_SESSION['username'],
        ]);
    }
}