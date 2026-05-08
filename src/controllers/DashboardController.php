<?php

require_once 'AppController.php';
require_once __DIR__.'/../repositories/UsersRepository.php';

class DashboardController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): DashboardController {
        if (is_null(self::$instance)) {
            self::$instance = new DashboardController();
        }

        return self::$instance;
    }

    public function index($id = null) {
        $this->requireAuth();

        $userId = $_SESSION['user_id'];

        return $this->render('dashboard', ['userId' => $userId]);
    }
}