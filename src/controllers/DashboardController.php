<?php

require_once 'AppController.php';

class DashboardController extends AppController {
    public static function getInstance(): DashboardController {
        if (is_null(self::$instance)) {
            self::$instance = new DashboardController();
        }

        return self::$instance;
    }

    public function index() {
        // TODO pobieranie danych z bazy
        // wstawianie zmiennych na widok

        return $this->render("index");
    }
}