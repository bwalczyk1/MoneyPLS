<?php

require_once __DIR__ . '/AppModel.php';

class Payment extends AppModel {
    public ?int $id;
    public int $groupId;
    public int $fromUserId;
    public int $toUserId;
    public float $amount;
    public ?string $note;
    public ?string $createdAt;

    public function __construct(
        int $groupId = 0,
        int $fromUserId = 0,
        int $toUserId = 0,
        float $amount = 0.0,
        ?string $note = null,
        ?int $id = null,
        ?string $createdAt = null
    ) {
        $this->id = $id;
        $this->groupId = $groupId;
        $this->fromUserId = $fromUserId;
        $this->toUserId = $toUserId;
        $this->amount = $amount;
        $this->note = $note;
        $this->createdAt = $createdAt;
    }

    public function validate(): bool {
        parent::validate();

        if ($this->amount <= 0) {
            $this->addError('amount', 'Amount must be greater than 0');
        }

        if ($this->fromUserId === $this->toUserId) {
            $this->addError('to_user_id', 'Cannot pay yourself');
        }

        return $this->isValid();
    }

    public static function fromArray(array $data): self {
        return new self(
            $data['group_id'] ?? 0,
            $data['from_user_id'] ?? 0,
            $data['to_user_id'] ?? 0,
            (float)($data['amount'] ?? 0),
            $data['note'] ?? null,
            $data['id'] ?? null,
            $data['created_at'] ?? null
        );
    }
}
