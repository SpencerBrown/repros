# https://downloads.mongodb.com/win32/mongodb-win32-x86_64-enterprise-windows-64-4.2.1.zip

$VERSION = $ARGS[0]

$ARCHIVE_NAME = ("mongodb-win32-x86_64-enterprise-windows-64-" + $VERSION)
$ZIP_NAME = ($ARCHIVE_NAME + ".zip")
$DOWNLOAD_URL = "https://downloads.mongodb.com/win32"
$MONGO_DIR = "C:\mongo"

$ZIP_PATH = ($MONGO_DIR + "\" + $ZIP_NAME)

$wc = New-Object System.Net.WebClient
$wc.DownloadFile( ($DOWNLOAD_URL + "/" + $ZIP_NAME), $ZIP_PATH )
Expand-Archive -LiteralPath $ZIP_PATH -DestinationPath $MONGO_DIR
del $ZIP_PATH

$VERSION_DIR = ($MONGO_DIR + "\" + $VERSION)
$ARCHIVE_DIR = ($MONGO_DIR + "\" + $ARCHIVE_NAME)
md $VERSION_DIR
move ($ARCHIVE_DIR + "\bin\*") ($VERSION_DIR + "\")
del -r $ARCHIVE_DIR