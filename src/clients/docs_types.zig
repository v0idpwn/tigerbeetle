pub const Docs = struct {
    readme: [:0]const u8,
    name: []const u8,
    markdown_name: []const u8,
    description: []const u8,
    install_commands: []const u8,
    examples: []const u8,

    client_object_example: []const u8,
    client_object_documentation: []const u8,

    create_accounts_example: []const u8,
    create_accounts_documentation: []const u8,

    account_flags_details: []const u8,

    lookup_accounts_example: []const u8,

    developer_setup_bash_commands: []const u8,
    developer_setup_windows_commands: []const u8,
    test_linux_docker_image: []const u8,
};
