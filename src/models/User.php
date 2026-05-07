<?php

require_once __DIR__ . '/AppModel.php';

class User extends AppModel {
    public ?int $id;
    public string $username;
    public string $email;
    public string $password;
    public ?string $fullName;
    public bool $isActive;
    public ?string $createdAt;
    public ?string $updatedAt;

    public function __construct(
        string $username = '',
        string $email = '',
        string $password = '',
        ?string $fullName = null,
        bool $isActive = true,
        ?int $id = null,
        ?string $createdAt = null,
        ?string $updatedAt = null
    ) {
        $this->id = $id;
        $this->username = $username;
        $this->email = $email;
        $this->password = $password;
        $this->fullName = $fullName;
        $this->isActive = $isActive;
        $this->createdAt = $createdAt;
        $this->updatedAt = $updatedAt;
    }

    public function validate(): bool {
        parent::validate();

        if (empty($this->username)) {
            $this->addError('username', 'Username is required');
        } elseif (strlen($this->username) > 50) {
            $this->addError('username', 'Username cannot exceed 50 characters');
        }

        if (empty($this->email)) {
            $this->addError('email', 'Email is required');
        } elseif (!filter_var($this->email, FILTER_VALIDATE_EMAIL)) {
            $this->addError('email', 'Invalid email format');
        } elseif (strlen($this->email) > 255) {
            $this->addError('email', 'Email cannot exceed 255 characters');
        }

        if (empty($this->password)) {
            $this->addError('password', 'Password is required');
        } elseif (strlen($this->password) < 8) {
            $this->addError('password', 'Password must be at least 8 characters');
        }

        return $this->isValid();
    }

    public static function fromArray(array $data): self {
        return new self(
            $data['username'] ?? '',
            $data['email'] ?? '',
            $data['password'] ?? '',
            $data['full_name'] ?? null,
            $data['is_active'] ?? true,
            $data['id'] ?? null,
            $data['created_at'] ?? null,
            $data['updated_at'] ?? null
        );
    }
}
