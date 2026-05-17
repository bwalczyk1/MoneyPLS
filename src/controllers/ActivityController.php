<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/ExpensesRepository.php';

class ActivityController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): ActivityController {
        if (is_null(self::$instance)) {
            self::$instance = new ActivityController();
        }

        return self::$instance;
    }

    public function index($id = null): void {
        $this->requireAuth();

        $userId = (int)$_SESSION['user_id'];
        $filter = $_GET['filter'] ?? 'all';

        $items = (new ExpensesRepository())->getRecentActivity($userId);

        if ($filter === 'expenses') {
            $items = array_filter($items, fn($i) => $i['type'] === 'expense');
        } elseif ($filter === 'payments') {
            $items = array_filter($items, fn($i) => $i['type'] === 'payment');
        }

        // Group by date label
        $grouped = [];
        $today     = date('Y-m-d');
        $yesterday = date('Y-m-d', strtotime('-1 day'));

        foreach ($items as $item) {
            $date = substr($item['created_at'], 0, 10);

            $label = match($date) {
                $today => 'Today',
                $yesterday => 'Yesterday',
                default => date('M j', strtotime($date)),
            };

            $grouped[$label][] = $item;
        }

        $this->render('activity', [
            'pageTitle'  => 'Activity — MoneyPLS',
            'activePage' => 'activity',
            'grouped'    => $grouped,
            'filter'     => $filter,
        ]);
    }
}
