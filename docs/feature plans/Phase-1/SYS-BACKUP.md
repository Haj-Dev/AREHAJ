# SYS-BACKUP - Backup and restore

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

## Added Features

- Automated task that makes a backup of the database outside of the database.
- Documented command or script that restores a backup.
- "The worst case data loss is stated and follows from the schedule."?
- Backups are also encrypted.

## Risks

- Backups fail to trigger.
- Backups are stored along with the database.
- Backups expose sensitive information
