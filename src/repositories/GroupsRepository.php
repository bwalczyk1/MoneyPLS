<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/Group.php';
require_once __DIR__ . '/../models/User.php';

class GroupsRepository extends Repository {

    public function getGroupsForUser(int $userId): array {
        $query = $this->database->connect()->prepare("
            SELECT g.* FROM groups g
            JOIN group_members gm ON gm.group_id = g.id
            WHERE gm.user_id = :user_id
            ORDER BY g.created_at DESC
        ");
        $query->bindParam(':user_id', $userId, PDO::PARAM_INT);
        $query->execute();
        return array_map(fn($row) => Group::fromArray($row), $query->fetchAll(PDO::FETCH_ASSOC));
    }

    public function getGroupById(int $id): ?Group {
        $query = $this->database->connect()->prepare("SELECT * FROM groups WHERE id = :id");
        $query->bindParam(':id', $id, PDO::PARAM_INT);
        $query->execute();
        $row = $query->fetch(PDO::FETCH_ASSOC);
        return $row ? Group::fromArray($row) : null;
    }

    public function createGroup(Group $group, array $memberIds): int {
        $conn = $this->database->connect();
        $conn->beginTransaction();
        try {
            $q = $conn->prepare("
                INSERT INTO groups (name, category, currency, created_by)
                VALUES (:name, :category, :currency, :created_by)
                RETURNING id
            ");
            $q->execute([
                ':name'       => $group->name,
                ':category'   => $group->category,
                ':currency'   => $group->currency,
                ':created_by' => $group->createdBy,
            ]);
            $groupId = (int)$q->fetchColumn();

            $allMembers = array_unique(array_merge([$group->createdBy], $memberIds));
            $qm = $conn->prepare("INSERT INTO group_members (group_id, user_id) VALUES (:group_id, :user_id)");
            foreach ($allMembers as $userId) {
                $qm->execute([':group_id' => $groupId, ':user_id' => $userId]);
            }

            $conn->commit();
            return $groupId;
        } catch (Exception $e) {
            $conn->rollBack();
            throw $e;
        }
    }

    public function getMembersForGroup(int $groupId): array {
        $query = $this->database->connect()->prepare("
            SELECT u.* FROM users u
            JOIN group_members gm ON gm.user_id = u.id
            WHERE gm.group_id = :group_id
            ORDER BY gm.joined_at ASC
        ");
        $query->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $query->execute();
        return array_map(fn($row) => User::fromArray($row), $query->fetchAll(PDO::FETCH_ASSOC));
    }

    public function getTotalSpentForGroup(int $groupId): float {
        $query = $this->database->connect()->prepare("
            SELECT COALESCE(SUM(amount), 0) FROM expenses WHERE group_id = :group_id
        ");
        $query->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $query->execute();
        return (float)$query->fetchColumn();
    }

    public function isMember(int $groupId, int $userId): bool {
        $query = $this->database->connect()->prepare("
            SELECT 1 FROM group_members WHERE group_id = :group_id AND user_id = :user_id
        ");
        $query->execute([':group_id' => $groupId, ':user_id' => $userId]);
        return (bool)$query->fetchColumn();
    }
}
