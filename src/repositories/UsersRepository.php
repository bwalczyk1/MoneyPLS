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
            "SELECT id, username, password FROM users WHERE email = :email"
        );
        $query->bindParam(':email', $email);
        $query->execute();

        $row = $query->fetch(PDO::FETCH_ASSOC);
        return $row ? User::fromArray($row) : null;
    }

    public function searchUsers(
        string $search,
        int $limit = 10,
        int $excludeId = 0,
    ): array {
        $query = $this->database->connect()->prepare("
            SELECT id, username FROM users
            WHERE username ILIKE :search AND id != :exclude
            ORDER BY username
            LIMIT :limit
        ");

        $pattern = '%' . $search . '%';
        $query->bindParam(':search', $pattern);
        $query->bindParam(':exclude', $excludeId, PDO::PARAM_INT);
        $query->bindParam(':limit', $limit, PDO::PARAM_INT);
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function createUser(
        string $email,
        string $hashedPassword,
        string $username,
        string $fullName = '',
    ): void {
        $query = $this->database->connect()->prepare(
            "INSERT INTO users (username, email, password, full_name) VALUES (?, ?, ?, ?)"
        );

        $query->execute([$username, $email, $hashedPassword, $fullName ?: null]);
    }
}