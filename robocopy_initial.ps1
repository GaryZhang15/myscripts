#moment garden service, initial backup
$mgsSourcePath = 'D:\CollaborationCorporation\MomentGardenAttachmentStorage'
$mgsDestinPath = 'G:\CollaborationCorporation\MomentGardenAttachmentStorage'

robocopy $mgsSourcePath $mgsDestinPath /e

#talk time service, initial backup
$ttsSourcePath = 'D:\CollaborationCorporation\TalkTimeAttachmentStorage'
$ttsDestinPath = 'G:\CollaborationCorporation\TalkTimeAttachmentStorage'

robocopy $ttsSourcePath $ttsDestinPath /e

#images, initial backup
$imgSource = 'D:\CollaborationCorporation\Images\Origin'
$imgDestin = 'G:\CollaborationCorporation\Images\Origin'

robocopy $imgSource $imgDestin /e