<?php

require_once 'AppController.php';
require_once __DIR__ . '/../repositories/UsersRepository.php';

class UsersController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): UsersController {
        if (is_null(self::$instance)) {
            self::$instance = new UsersController();
        }
        return self::$instance;
    }

    public function search(): void {
        $this->requireAuth();

        $search  = trim($_GET['search'] ?? '');
        $limit   = min((int)($_GET['limit'] ?? 10), 50);
        $exclude = (int)$_SESSION['user_id'];

        $users = (new UsersRepository())->searchUsers($search, $limit, $exclude);

        header('Content-Type: application/json');
        echo json_encode($users);
        exit;
    }
}
