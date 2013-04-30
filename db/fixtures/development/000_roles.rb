Role.delete_all

Role.seed(:id, [
    {id: 1, :name => 'admin'},
    {id: 2, :name => 'user'},
    {id: 3, :name => 'moderator'},
    {id: 4, :name => 'VIP'}
])