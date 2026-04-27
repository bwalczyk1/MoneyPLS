<?php

require_once 'AppController.php';
require_once __DIR__.'/../repositories/UsersRepository.php';

class SecurityController extends AppController {
    public static function getInstance(): SecurityController {
        if (is_null(self::$instance)) {
            self::$instance = new SecurityController();
        }

        return self::$instance;
    }

    public function login() {
        if (!$this->isPost()) {
            return $this->render('login');
        }

        $email = $_POST["email"] ?? '';
        $password = $_POST["password"] ?? '';

        // var_dump($email);

        if (empty($email) || empty($password)) {
            return $this->render('login', ['messages' => 'Fill all fields']);
        }

       //TODO get from database user with given email
        $usersRepository = new UsersRepository();
        $user = $usersRepository->getUserByEmail($email);
      
        if (!$user) {
            return $this->render('login', ['messages' => 'User not found']);
        }

        if (!password_verify($password, $user['password'])) {
            return $this->render('login', ['messages' => 'Wrong password']);
        }

        // TODO możemy przechowywać sesje użytkowika lub token
        // setcookie("username", $user['email'], time() + 3600, '/');

        $url = "http://$_SERVER[HTTP_HOST]";
        header("Location: {$url}/dashboard");
    }

    public function register() {
        if (!$this->isPost()) {
            return $this->render('register');
        }

        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $username = $_POST['username'] ?? '';

        if (empty($email) || empty($password) || empty($username)) {
            return $this->render('register', ['messages' => 'Fill all fields']);
        }

	    // TODO check if user exists
        $usersRepository = new UsersRepository();
        $existingUser = $usersRepository->getUserByEmail($email);

        if (!empty($existingUser)) {
            return $this->render('register', ['messages' => 'Email already used']);
        }

        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

        // todo insert user to dabase
        $usersRepository->createUser($email, $hashedPassword, $username);

        $url = "http://$_SERVER[HTTP_HOST]";
        header("Location: {$url}/login");
    }
}