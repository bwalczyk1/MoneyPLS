<?php

require_once 'AppController.php';

class LandingController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): LandingController {
        if (is_null(self::$instance)) {
            self::$instance = new LandingController();
        }
        return self::$instance;
    }

    public function index($id = null): void {
        if (!empty($_SESSION['user_id'])) {
            $this->redirect('dashboard');
        }
        $this->render('landing', ['pageTitle' => 'MoneyPLS — Split expenses, not friendships']);
    }
}
