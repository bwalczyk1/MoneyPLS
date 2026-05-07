<?php

require_once __DIR__ . '/AppModel.php';

class Group extends AppModel {
    public ?int $id;
    public string $name;
    public string $category;
    public string $currency;
    public int $createdBy;
    public ?string $createdAt;

    private const CATEGORIES = ['general', 'travel', 'food', 'rent', 'entertainment', 'other'];
    private const CURRENCIES = ['USD', 'EUR', 'PLN', 'GBP'];

    public function __construct(
        string $name = '',
        string $category = 'general',
        string $currency = 'USD',
        int $createdBy = 0,
        ?int $id = null,
        ?string $createdAt = null
    ) {
        $this->id = $id;
        $this->name = $name;
        $this->category = $category;
        $this->currency = $currency;
        $this->createdBy = $createdBy;
        $this->createdAt = $createdAt;
    }

    public function validate(): bool {
        parent::validate();

        if (empty($this->name)) {
            $this->addError('name', 'Group name is required');
        } elseif (strlen($this->name) > 100) {
            $this->addError('name', 'Group name cannot exceed 100 characters');
        }

        if (!in_array($this->category, self::CATEGORIES)) {
            $this->addError('category', 'Invalid category');
        }

        if (!in_array($this->currency, self::CURRENCIES)) {
            $this->addError('currency', 'Invalid currency');
        }

        return $this->isValid();
    }

    public static function fromArray(array $data): self {
        return new self(
            $data['name'] ?? '',
            $data['category'] ?? 'general',
            $data['currency'] ?? 'USD',
            $data['created_by'] ?? 0,
            $data['id'] ?? null,
            $data['created_at'] ?? null
        );
    }

    public static function categories(): array {
        return self::CATEGORIES;
    }

    public static function currencies(): array {
        return self::CURRENCIES;
    }
}
