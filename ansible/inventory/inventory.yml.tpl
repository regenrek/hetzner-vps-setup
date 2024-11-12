all:
  children:
    controller:
      hosts:
        # insert your server ip or hostname here
  vars:
    ansible_user: admin
    ansible_port: 122
    ansible_become: true
    ansible_become_method: sudo
