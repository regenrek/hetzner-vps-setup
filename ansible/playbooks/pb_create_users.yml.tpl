---
- name: Manage Users
  hosts: all
  become: yes
  vars:
    users:
      - name: john # insert username here
        sudo: true
        shell: /bin/bash
        groups:
          - sudo
          - ssh-user
        password_hash: "" # insert password hash here (mkpasswd -m sha-512)
        ssh_authorized_keys: # insert ssh public key here
          - ""

  # uncomment to create user more groups
  # tasks:
  #   - name: Create user groups
  #     group:
  #       name: "{{ item }}"
  #       state: present
  #     loop:
  #       - sudo
  #       - ssh-user

    - name: Create users
      user:
        name: "{{ item.name }}"
        shell: "{{ item.shell }}"
        groups: "{{ item.groups | join(',') }}"
        password: "{{ item.password_hash }}"
        update_password: on_create
      loop: "{{ users }}"

    - name: Set up SSH authorized keys
      authorized_key:
        user: "{{ item.0.name }}"
        key: "{{ item.1 }}"
        state: present
      loop: "{{ users | subelements('ssh_authorized_keys') }}"

    - name: Ensure sudo access
      lineinfile:
        path: /etc/sudoers.d/users
        line: "{{ item.name }} ALL=(ALL) NOPASSWD:ALL"
        create: yes
        mode: '0440'
        validate: 'visudo -cf %s'
      loop: "{{ users | selectattr('sudo', 'equalto', true) | list }}"

    - name: Set up SSH directories
      file:
        path: "/home/{{ item.name }}/.ssh"
        state: directory
        mode: '0700'
        owner: "{{ item.name }}"
        group: "{{ item.name }}"
      loop: "{{ users }}" 