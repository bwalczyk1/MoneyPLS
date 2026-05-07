<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/User.php';

class UsersRepository extends Repository {

    public function getUsers(): array
    {
        $query = $this->database->connect()->prepare("SELECT * FROM users");
        $query->execute();

        return array_map(
            fn($row) => User::fromArray($row),
            $query->fetchAll(PDO::FETCH_ASSOC)
        );
    }

    public function getUserByEmail(string $email): ?User
    {
        $query = $this->database->connect()->prepare(
            "SELECT * FROM users WHERE email = :email"
        );
        $query->bindParam(':email', $email);
        $query->execute();

        $row = $query->fetch(PDO::FETCH_ASSOC);
        return $row ? User::fromArray($row) : null;
    }

    public function createUser(string $email, string $hashedPassword, string $username): void
    {
        $query = $this->database->connect()->prepare(
            "INSERT INTO users (username, email, password) VALUES (?, ?, ?)"
        );
        $query->execute([$username, $email, $hashedPassword]);
    }
}