document.addEventListener('DOMContentLoaded', function () {
    var list   = document.getElementById('members-list');
    var input  = document.getElementById('member-search');
    if (!list || !input) return;

    var prechecked = JSON.parse(list.dataset.prechecked || '[]');
    var checkedIds = new Map(); // id (number) → username (string)

    prechecked.forEach(function (id) {
        checkedIds.set(id, null); // username filled in after first fetch
    });

    function renderUsers(users) {
        // Update usernames for prechecked IDs we now know about
        users.forEach(function (u) {
            if (checkedIds.has(u.id)) {
                checkedIds.set(u.id, u.username);
            }
        });

        var resultIds = new Set(users.map(function (u) { return u.id; }));
        list.innerHTML = '';

        // Render search results
        users.forEach(function (u) {
            list.appendChild(makeItem(u.id, u.username));
        });

        // Render hidden inputs for checked users not in current results
        checkedIds.forEach(function (username, id) {
            if (!resultIds.has(id)) {
                var hidden = document.createElement('input');
                hidden.type    = 'hidden';
                hidden.name    = 'members[]';
                hidden.value   = id;
                list.appendChild(hidden);
            }
        });
    }

    function makeItem(id, username) {
        var label = document.createElement('label');
        label.className = 'member-item';
        label.dataset.username = username.toLowerCase();

        var cb = document.createElement('input');
        cb.type    = 'checkbox';
        cb.name    = 'members[]';
        cb.value   = id;
        cb.checked = checkedIds.has(id);

        cb.addEventListener('change', function () {
            if (this.checked) {
                checkedIds.set(id, username);
            } else {
                checkedIds.delete(id);
            }
        });

        var avatar = document.createElement('span');
        avatar.className   = 'member-avatar';
        avatar.textContent = username.charAt(0).toUpperCase();

        var name = document.createElement('span');
        name.className   = 'member-name';
        name.textContent = username;

        label.appendChild(cb);
        label.appendChild(avatar);
        label.appendChild(name);
        return label;
    }

    function fetchUsers(search) {
        fetch('/api/users?search=' + encodeURIComponent(search) + '&limit=10')
            .then(function (r) { return r.json(); })
            .then(renderUsers);
    }

    var debounceTimer;
    input.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        var q = this.value;
        debounceTimer = setTimeout(function () { fetchUsers(q); }, 300);
    });

    fetchUsers('');
});
