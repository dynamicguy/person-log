Permission.delete_all

Permission.seed(:id, [
    {id: 1, action: "read", subject_class: "User", role_id: 2},
    {id: 2, action: "read", subject_class: "Visit", role_id: 2},
    {id: 3, action: "read", subject_class: "Url", role_id: 2},
    {id: 4, action: "read", subject_class: "Query", role_id: 2},
    {id: 5, action: "read", subject_class: "PostalAddress", role_id: 2},
    {id: 6, action: "read", subject_class: "Position", role_id: 2},
    {id: 7, action: "read", subject_class: "Authentication", role_id: 2},
    {id: 8, action: "read", subject_class: "Company", role_id: 2},
    {id: 9, action: "read", subject_class: "Education", role_id: 2},

    {id: 10, action: "read", subject_class: "User", role_id: 3},
    {id: 11, action: "read", subject_class: "Visit", role_id: 3},
    {id: 12, action: "read", subject_class: "Url", role_id: 3},
    {id: 13, action: "read", subject_class: "Query", role_id: 3},
    {id: 14, action: "read", subject_class: "PostalAddress", role_id: 3},
    {id: 15, action: "read", subject_class: "Position", role_id: 3},
    {id: 16, action: "read", subject_class: "Authentication", role_id: 3},
    {id: 17, action: "read", subject_class: "Company", role_id: 3},
    {id: 18, action: "read", subject_class: "Education", role_id: 3}

])
