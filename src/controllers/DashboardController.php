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
        if (empty($_SESSION['user_id'])) {
            $url = "http://$_SERVER[HTTP_HOST]";
            header("Location: {$url}/login");
            return;
        }

        $title = "INDEX";

        $usersRepository = new UsersRepository();
        $users = $usersRepository->getUsers();

        return $this->render("index", ["title" => $title, "users" => $users]);
    }
}