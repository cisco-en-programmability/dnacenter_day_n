# Cisco DNA Center Day N Operations


This repo is for an application that will automate Day N operations using Cisco DNA Center APIs

**Cisco Products & Services:**

- Cisco DNA Center, devices managed by Cisco DNA Center

**Tools & Frameworks:**

- Python environment to run the application
- Cisco DNA Center Python SDK, Cisco DNA Center Ansible Collection

**Usage**

This application will automate Day N operations, creating device inventories, using the Cisco DNA Center REST APIs

"inventory_collection_sdk.py" Python app workflow:
- create device inventory - hostname, device management IP address, device UUID, software version,
    device family, role, site, site UUID
- create access point inventory - hostname, device management IP address, device UUID, software version,
    device family, role, site, site UUID
- identify device image compliance state and create image non-compliant inventories
- save all files to local folder, formatted using JSON and YAML
- push the inventory files to GitHub repo

Sample output:

```shell
INFO:root:App "inventory_collection_sdk.py" Start, 2022-05-18 15:34:18
INFO:root:Number of devices managed by Cisco DNA Center: 13
INFO:root:Collected the device list from Cisco DNA Center
INFO:root:Collected the device inventory from Cisco DNA Center
INFO:root:Saved the device inventory to file "device_inventory.json"
INFO:root:Saved the device inventory to file "device_inventory.yaml"
INFO:root:Saved the device inventory to file "ap_inventory.json"
INFO:root:Saved the device inventory to file "ap_inventory.yaml"
INFO:root:Number of devices image non-compliant: 3
INFO:root:Image non-compliant devices: 
INFO:root:    LO-CN, Site Hierarchy: Global/OR/LO/Floor-3
INFO:root:    LO-BN, Site Hierarchy: Global/OR/LO/Floor-3
INFO:root:    NYC-ACCESS, Site Hierarchy: Global/NY/NYC/Floor-8
INFO:root:Saved the image non-compliant device inventory to file "non_compliant_devices.json"
INFO:root:Saved the image non-compliant device inventory to file "non_compliant_devices.yaml"
INFO:root:GitHub push for file: ap_inventory.yaml
INFO:root:GitHub push for file: non_compliant_devices.json
INFO:root:GitHub push for file: ap_inventory.json
INFO:root:GitHub push for file: non_compliant_devices.yaml
INFO:root:GitHub push for file: device_inventory.json
INFO:root:GitHub push for file: device_inventory.yaml
INFO:root:End of Application "inventory_collection_sdk.py" Run: 2022-05-18 15:34:33
```

"deploy_cli_templates_ansible.yaml" Ansible playbook workflow:
- pull from GitHub the latest templates
- optional, pull from GitHub the device inventory (not implemented)
- identify devices that match the device filter
- select the devices that are managed and reachable by Cisco DNA Center
- create a new template project if not existing
- create and commit CLI template
- deploy the template to selected devices
- create deployment status report

To run the playbook use this command by providing the name of the deployment template, matching a file form your GitHub repo:

```
ansible-playbook -e "deployment_name=csr_updates.yaml" deploy_cli_templates_ansible.yaml
```

Sample Output:

```shell
(venv) gzapodea@GZAPODEA-M-G7G6 ansible % ansible-playbook -e "deployment_name=csr_updates.yaml" deploy_cli_templates_ansible.yaml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Ansible CLI Templates] *************************************************************************************************************************************************************************

TASK [Get start timestamp from the system] ***********************************************************************************************************************************************************
changed: [localhost]

TASK [Print playbook start timestamp] ****************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "--Deploy CLI Templates Ansible-- playbook start time: 2022-05-18T15-39-18"
}

TASK [Print user input deployment name] **************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "--Deploy CLI Templates Ansible-- deployment name: csr_updates.yaml"
}

TASK [Update templates folder from the GitHub repo] **************************************************************************************************************************************************
ok: [localhost]

TASK [Include the new downloaded vars file] **********************************************************************************************************************************************************
ok: [localhost]

TASK [include_tasks] *********************************************************************************************************************************************************************************
included: /Users/gzapodea/PythonCode/dnacenter_day_n/ansible/create_template_tasks.yaml for localhost

TASK [Print the CLI Template] ************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "CLI Template: !\nno snmp-server host 10.93.135.30 version 2c RO\nno snmp-server host 10.93.130.50 version 2c RW\n!\nntp server 171.68.48.78\nno ntp server 171.68.48.80\n"
}

TASK [Verify if existing project with the name: Ansible_Project] *************************************************************************************************************************************
ok: [localhost]

TASK [Project not found] *****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Create new project] ****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Print create project task id] ******************************************************************************************************************************************************************
skipping: [localhost]

TASK [Sleep for 10 seconds to create project and continue with play] *********************************************************************************************************************************
skipping: [localhost]

TASK [Get the project id] ****************************************************************************************************************************************************************************
ok: [localhost]

TASK [Parse project id] ******************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print project id] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Project id is: a9b436ab-3c57-4ef7-893a-6904d385e183"
}

TASK [Create new CLI Template with the name: csrs_ntp_snmp-2022-05-18T15-39-18] **********************************************************************************************************************
ok: [localhost]

TASK [Parse the create template task id] *************************************************************************************************************************************************************
ok: [localhost]

TASK [Print create template task id] *****************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Create a new template, task id is: e290f327-19bc-4dea-a1f2-4e8b1d8dace5"
}

TASK [Sleep for 10 seconds to create template and continue with play] ********************************************************************************************************************************
ok: [localhost]

TASK [Get the template id] ***************************************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the template id] *************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print template id] *****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Template id is: f637b132-cfba-45df-921d-965312a37e2d}"
}

TASK [Commit template] *******************************************************************************************************************************************************************************
ok: [localhost]

TASK [Sleep for 5 seconds to commit template and continue with play] *********************************************************************************************************************************
ok: [localhost]

TASK [Print filter info to select devices to be configured with the CLI Template] ********************************************************************************************************************
ok: [localhost] => {
    "msg": "Filter: device_family, value: Cisco Cloud Services Router 1000V"
}

TASK [Create an empty "device_hostname" list set_fact] ***********************************************************************************************************************************************
ok: [localhost]

TASK [Append the device hostnames matching the filter] ***********************************************************************************************************************************************
[WARNING]: conditional statements should not include jinja2 templating delimiters such as {{ }} or {% %}. Found: item.{{ filter }} == "{{ filter_value }}"
skipping: [localhost] => (item={'hostname': 'C9800-CL', 'device_ip': '10.93.141.38', 'device_id': 'e5facea9-6097-45b7-9c1f-1c8c7224e812', 'version': '17.4.1', 'device_family': 'Cisco Catalyst 9800-CL Wireless Controller for Cloud', 'role': 'ACCESS', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'}) 
skipping: [localhost] => (item={'hostname': 'LO-BN', 'device_ip': '10.93.141.28', 'device_id': 'db05ad49-2c8d-4094-9df6-3a03f9b28069', 'version': '17.6.1', 'device_family': 'Cisco Catalyst 9300 Switch', 'role': 'DISTRIBUTION', 'site': 'Global/OR/LO/Floor-3', 'site_id': '3bb9e022-b230-40f2-a17e-f588376f31e3'}) 
skipping: [localhost] => (item={'hostname': 'LO-CN', 'device_ip': '10.93.141.20', 'device_id': '6a612b05-1c89-4d0a-a4d3-94ec5e5a7a57', 'version': '17.6.1', 'device_family': 'Cisco Catalyst 9300 Switch', 'role': 'DISTRIBUTION', 'site': 'Global/OR/LO/Floor-3', 'site_id': '3bb9e022-b230-40f2-a17e-f588376f31e3'}) 
skipping: [localhost] => (item={'hostname': 'LO-EDGE', 'device_ip': '10.93.141.19', 'device_id': 'cd7c74bc-8301-4be8-bcbb-0547be8d03b7', 'version': '16.9.5', 'device_family': 'Cisco Catalyst38xx stack-able ethernet switch', 'role': 'ACCESS', 'site': 'Global/OR/LO/Floor-3', 'site_id': '3bb9e022-b230-40f2-a17e-f588376f31e3'}) 
skipping: [localhost] => (item={'hostname': 'NYC-ACCESS', 'device_ip': '10.93.141.26', 'device_id': '20937bce-b8d8-42c2-b3a0-08cda93fae1e', 'version': '17.3.2a', 'device_family': 'Cisco Catalyst 9300 Switch', 'role': 'DISTRIBUTION', 'site': 'Global/NY/NYC/Floor-8', 'site_id': '755df6b0-6bdb-4d17-8983-906645e6bf98'}) 
ok: [localhost] => (item={'hostname': 'NYC-RO', 'device_ip': '10.93.141.25', 'device_id': '3c4aea42-2e1e-4f45-8fcd-530cb97f934f', 'version': '17.3.2', 'device_family': 'Cisco Cloud Services Router 1000V', 'role': 'BORDER ROUTER', 'site': 'Global/NY/NYC/Floor-8', 'site_id': '755df6b0-6bdb-4d17-8983-906645e6bf98'})
skipping: [localhost] => (item={'hostname': 'PDX-CORE1', 'device_ip': '10.93.141.18', 'device_id': 'd11fda6f-d379-4839-aefa-0f68e151e59b', 'version': '16.9.5', 'device_family': 'Cisco Catalyst38xx stack-able ethernet switch', 'role': 'CORE', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'}) 
skipping: [localhost] => (item={'hostname': 'PDX-M', 'device_ip': '10.93.141.17', 'device_id': '3aa5a467-1c7b-415b-bcdb-1fea7058f805', 'version': '16.9.5', 'device_family': 'Cisco Catalyst38xx stack-able ethernet switch', 'role': 'ACCESS', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'}) 
ok: [localhost] => (item={'hostname': 'PDX-RN', 'device_ip': '10.93.141.22', 'device_id': '657008e6-6160-481e-aa7d-a5b3513b1f7c', 'version': '17.3.2', 'device_family': 'Cisco Cloud Services Router 1000V', 'role': 'BORDER ROUTER', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'})
ok: [localhost] => (item={'hostname': 'PDX-RO', 'device_ip': '10.93.141.23', 'device_id': '01f7cdf2-2298-42c7-bb74-dc68e3c3a051', 'version': '17.3.2', 'device_family': 'Cisco Cloud Services Router 1000V', 'role': 'BORDER ROUTER', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'})
skipping: [localhost] => (item={'hostname': 'PDX-STACK', 'device_ip': '10.93.141.21', 'device_id': '224a481b-da09-4d57-bcdd-f5fa962edf32', 'version': '17.3.2a', 'device_family': 'Cisco Catalyst 9300 Switch', 'role': 'DISTRIBUTION', 'site': 'Global/OR/PDX/Floor-2', 'site_id': '17d5b2b9-ff29-4320-bdab-fd6c3d7df09d'}) 
ok: [localhost] => (item={'hostname': 'SP', 'device_ip': '10.93.141.24', 'device_id': '5e75ac86-5811-40eb-b974-6f3c2617505d', 'version': '17.3.2', 'device_family': 'Cisco Cloud Services Router 1000V', 'role': 'BORDER ROUTER', 'site': 'Global/CO/ENGL/Floor-5', 'site_id': 'f2a5bd0d-4ec9-44ed-bf6a-a43b12378ff1'})

TASK [Print devices hostnames matching the filter] ***************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "The devices hostnames that match the filter: ['NYC-RO', 'PDX-RN', 'PDX-RO', 'SP']"
}

TASK [Deploy template to devices matching the filter] ************************************************************************************************************************************************
included: /Users/gzapodea/PythonCode/dnacenter_day_n/ansible/deploy_template_tasks.yaml for localhost => (item=NYC-RO)
included: /Users/gzapodea/PythonCode/dnacenter_day_n/ansible/deploy_template_tasks.yaml for localhost => (item=PDX-RN)
included: /Users/gzapodea/PythonCode/dnacenter_day_n/ansible/deploy_template_tasks.yaml for localhost => (item=PDX-RO)
included: /Users/gzapodea/PythonCode/dnacenter_day_n/ansible/deploy_template_tasks.yaml for localhost => (item=SP)

TASK [Device hostname] *******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Configuring the device with the name: NYC-RO"
}

TASK [Set flag for device not managed or unreachable] ************************************************************************************************************************************************
ok: [localhost]

TASK [Verify if the device NYC-RO is managed by Cisco DNA Center] ************************************************************************************************************************************
ok: [localhost]

TASK [Device deployment status update - device not managed] ******************************************************************************************************************************************
skipping: [localhost]

TASK [Device not managed] ****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not managed] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device deployment status update - device not reachable] ****************************************************************************************************************************************
skipping: [localhost]

TASK [Device not reachable] **************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not reachable] *************************************************************************************************************************************************************
skipping: [localhost]

TASK [Deploy template csrs_ntp_snmp to device NYC-RO] ************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task id] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [Sleep for 10 seconds to deploy template and continue with play] ********************************************************************************************************************************
ok: [localhost]

TASK [Verify the template deployment result] *********************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task result] **************************************************************************************************************************************************************
ok: [localhost]

TASK [Print successful template deployment result] ***************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Template deployment successful"
}

TASK [Update deployment successful status] ***********************************************************************************************************************************************************
ok: [localhost]

TASK [Print unsuccessful template deployment result] *************************************************************************************************************************************************
skipping: [localhost]

TASK [Update deployment failed status] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device hostname] *******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Configuring the device with the name: PDX-RN"
}

TASK [Set flag for device not managed or unreachable] ************************************************************************************************************************************************
ok: [localhost]

TASK [Verify if the device PDX-RN is managed by Cisco DNA Center] ************************************************************************************************************************************
ok: [localhost]

TASK [Device deployment status update - device not managed] ******************************************************************************************************************************************
skipping: [localhost]

TASK [Device not managed] ****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not managed] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device deployment status update - device not reachable] ****************************************************************************************************************************************
skipping: [localhost]

TASK [Device not reachable] **************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not reachable] *************************************************************************************************************************************************************
skipping: [localhost]

TASK [Deploy template csrs_ntp_snmp to device PDX-RN] ************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task id] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [Sleep for 10 seconds to deploy template and continue with play] ********************************************************************************************************************************
ok: [localhost]

TASK [Verify the template deployment result] *********************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task result] **************************************************************************************************************************************************************
ok: [localhost]

TASK [Print successful template deployment result] ***************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Template deployment successful"
}

TASK [Update deployment successful status] ***********************************************************************************************************************************************************
ok: [localhost]

TASK [Print unsuccessful template deployment result] *************************************************************************************************************************************************
skipping: [localhost]

TASK [Update deployment failed status] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device hostname] *******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Configuring the device with the name: PDX-RO"
}

TASK [Set flag for device not managed or unreachable] ************************************************************************************************************************************************
ok: [localhost]

TASK [Verify if the device PDX-RO is managed by Cisco DNA Center] ************************************************************************************************************************************
ok: [localhost]

TASK [Device deployment status update - device not managed] ******************************************************************************************************************************************
skipping: [localhost]

TASK [Device not managed] ****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not managed] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device deployment status update - device not reachable] ****************************************************************************************************************************************
skipping: [localhost]

TASK [Device not reachable] **************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not reachable] *************************************************************************************************************************************************************
skipping: [localhost]

TASK [Deploy template csrs_ntp_snmp to device PDX-RO] ************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task id] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [Sleep for 10 seconds to deploy template and continue with play] ********************************************************************************************************************************
ok: [localhost]

TASK [Verify the template deployment result] *********************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task result] **************************************************************************************************************************************************************
ok: [localhost]

TASK [Print successful template deployment result] ***************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Template deployment successful"
}

TASK [Update deployment successful status] ***********************************************************************************************************************************************************
ok: [localhost]

TASK [Print unsuccessful template deployment result] *************************************************************************************************************************************************
skipping: [localhost]

TASK [Update deployment failed status] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device hostname] *******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Configuring the device with the name: SP"
}

TASK [Set flag for device not managed or unreachable] ************************************************************************************************************************************************
ok: [localhost]

TASK [Verify if the device SP is managed by Cisco DNA Center] ****************************************************************************************************************************************
ok: [localhost]

TASK [Device deployment status update - device not managed] ******************************************************************************************************************************************
skipping: [localhost]

TASK [Device not managed] ****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not managed] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Device deployment status update - device not reachable] ****************************************************************************************************************************************
skipping: [localhost]

TASK [Device not reachable] **************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Set flag for device not reachable] *************************************************************************************************************************************************************
skipping: [localhost]

TASK [Deploy template csrs_ntp_snmp to device SP] ****************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task id] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [Sleep for 10 seconds to deploy template and continue with play] ********************************************************************************************************************************
ok: [localhost]

TASK [Verify the template deployment result] *********************************************************************************************************************************************************
ok: [localhost]

TASK [Parse the deployment task result] **************************************************************************************************************************************************************
ok: [localhost]

TASK [Print successful template deployment result] ***************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Template deployment successful"
}

TASK [Update deployment successful status] ***********************************************************************************************************************************************************
ok: [localhost]

TASK [Print unsuccessful template deployment result] *************************************************************************************************************************************************
skipping: [localhost]

TASK [Update deployment failed status] ***************************************************************************************************************************************************************
skipping: [localhost]

TASK [Print deployment status] ***********************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "The deployment status is: [{'NYC-RO': 'Template deployment successful'}, {'PDX-RN': 'Template deployment successful'}, {'PDX-RO': 'Template deployment successful'}, {'SP': 'Template deployment successful'}]"
}

TASK [Get end timestamp from the system] *************************************************************************************************************************************************************
changed: [localhost]

TASK [Print timestamp] *******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "--Deploy CLI Templates Ansible-- playbook end time: 2022-05-18T15-40-40"
}

PLAY RECAP *******************************************************************************************************************************************************************************************
localhost                  : ok=71   changed=2    unreachable=0    failed=0    skipped=36   rescued=0    ignored=0   


```

**License**

This project is licensed to you under the terms of the [Cisco Sample Code License](./LICENSE).


