# Ansible Role for the node_exporter

![molecule](https://github.com/elan-ev/monitoring_loki/actions/workflows/molecule.yml/badge.svg)

Install the latest [node_exporter](https://github.com/prometheus/node_exporter) version with [ansible](https://docs.ansible.com/).

## Role Variables

Currently, there are no variable to be set. The role just installs the node_exporter.

## Example Playbook

Just add the role to your playbook:

```yaml
- hosts: all
  become: true
  roles:
    - elan.monitoring_node_exporter
```

## Development

For development and testing you can use [molecule](https://molecule.readthedocs.io/en/latest/).
With podman as driver you can install it like this – preferably in a virtual environment (if you use docker, substitute `podman` with `docker`):

```bash
pip install -r .dev_requirements.txt
```

Then you can *create* the test instances, apply the ansible config (*converge*) and *destroy* the test instances with these commands:

```bash
molecule create
molecule converge
molecule destroy
```

If you want to inspect a running test instance use `molecule login --host <instance_name>`, where you replace `<instance_name>` with the desired value.

## License

[BSD-3-Clause](LICENSE)

## Author Information

[ELAN e.V](https://elan-ev.de/)
