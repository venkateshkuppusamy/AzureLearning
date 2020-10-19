
#!/bin/bash

groupname="myResourceGroup"
webappname="<replace-with-your-app-name>"

# List statuses of all backups that are complete or currently executing.
    az webapp config backup list --resource-group venkibackuprg --webapp-name venkiapp123

# Note the backupItemName and storageAccountUrl properties of the backup you want to restore

# Restore the app by overwriting it with the backup data
# Be sure to replace <backupItemName> and <storageAccountUrl>
    az webapp config backup restore --resource-group venkibackuprg --webapp-name venkiapp123 --backup-name venkiapp123bkp2 ^
    --container-url "https://venkibackupstgacc.blob.core.windows.net/venkibackupcontainer?se=2021-01-01T00%3A00%3A00Z&sp=rwdl&sv=2018-11-09&sr=c&sig=qadUGglaQcxGJu4ucGaxjvX5XcNC9vzmPLnBjTM73QU%3D" --overwrite