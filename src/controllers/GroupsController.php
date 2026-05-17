<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/GroupsRepository.php';
require_once __DIR__ . '/../repositories/BalancesRepository.php';
require_once __DIR__ . '/../models/Group.php';

class GroupsController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): GroupsController {
        if (is_null(self::$instance)) {
            self::$instance = new GroupsController();
        }
        return self::$instance;
    }

    public function index($id = null): void {
        $this->requireAuth();

        $userId = $_SESSION['user_id'];
        $repo = new GroupsRepository();
        $groups = $repo->getGroupsForUser($userId);

        $groupsData = [];

        foreach ($groups as $group) {
            $members = $repo->getMembersForGroup($group->id);
            $total   = $repo->getTotalSpentForGroup($group->id);
            $groupsData[] = ['group' => $group, 'members' => $members, 'total' => $total];
        }

        $this->render('groups', [
            'pageTitle'  => 'Groups — MoneyPLS',
            'activePage' => 'groups',
            'groupsData' => $groupsData,
        ]);
    }

    public function show($id): void {
        $this->requireAuth();

        $userId = (int)$_SESSION['user_id'];
        $groupId = (int)$id;

        $repo = new GroupsRepository();
        $group = $repo->getGroupById($groupId);

        if (!$group || !$repo->isMember($groupId, $userId)) {
            $this->notFound();

            return;
        }

        $members = $repo->getMembersForGroup($groupId);
        $total   = $repo->getTotalSpentForGroup($groupId);

        require_once __DIR__ . '/../repositories/ExpensesRepository.php';
        $expRepo   = new ExpensesRepository();
        $expenses  = $expRepo->getExpensesForGroup($groupId);

        $this->render('group-detail', [
            'pageTitle'  => h($group->name) . ' — MoneyPLS',
            'activePage' => 'groups',
            'group'      => $group,
            'members'    => $members,
            'total'      => $total,
            'expenses'   => $expenses,
            'activeTab'  => 'expenses',
            'userId'     => $userId,
        ]);
    }

    public function showBalances($id): void {
        $this->requireAuth();

        $userId  = (int)$_SESSION['user_id'];
        $groupId = (int)$id;

        $repo = new GroupsRepository();
        $group = $repo->getGroupById($groupId);

        if (!$group || !$repo->isMember($groupId, $userId)) {
            $this->notFound();
            return;
        }

        $members  = $repo->getMembersForGroup($groupId);
        $total    = $repo->getTotalSpentForGroup($groupId);
        $balRepo  = new BalancesRepository();
        $balances = $balRepo->getGroupBalances($groupId);

        $memberMap = [];

        foreach ($members as $m) {
            $memberMap[$m->id] = $m->username;
        }

        $this->render('group-detail', [
            'pageTitle'  => h($group->name) . ' — MoneyPLS',
            'activePage' => 'groups',
            'group'      => $group,
            'members'    => $members,
            'total'      => $total,
            'balances'   => $balances,
            'memberMap'  => $memberMap,
            'activeTab'  => 'balances',
            'userId'     => $userId,
        ]);
    }

    public function create($id = null): void {
        $this->requireAuth();
        $userId = (int)$_SESSION['user_id'];

        if ($this->isGet()) {
            require_once __DIR__ . '/../repositories/UsersRepository.php';
            $users = (new UsersRepository())->getUsers();
            $this->render('group-form', [
                'pageTitle'  => 'New Group — MoneyPLS',
                'activePage' => 'groups',
                'users'      => $users,
                'categories' => Group::categories(),
                'currencies' => Group::currencies(),
            ]);

            return;
        }

        $name      = trim($_POST['name'] ?? '');
        $category  = $_POST['category'] ?? 'general';
        $currency  = $_POST['currency'] ?? 'USD';
        $memberIds = array_map('intval', $_POST['members'] ?? []);

        $group = new Group($name, $category, $currency, $userId);

        if (!$group->validate()) {
            require_once __DIR__ . '/../repositories/UsersRepository.php';
            $users = (new UsersRepository())->getUsers();
            $this->render('group-form', [
                'pageTitle'  => 'New Group — MoneyPLS',
                'activePage' => 'groups',
                'users'      => $users,
                'categories' => Group::categories(),
                'currencies' => Group::currencies(),
                'errors'     => $group->getErrors(),
                'old'        => $_POST,
            ]);

            return;
        }

        $groupId = (new GroupsRepository())->createGroup($group, $memberIds);
        $this->redirect("groups/{$groupId}");
    }
}
