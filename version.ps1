$VERSION = $ARGS[0]

$MONGO_DIR = "C:\mongo"
$MONGO_LINK = "mongodb"

if($ARGS.Count -eq 0) {
    dir $MONGO_DIR
    mongo --version
} else {
    $PATH = ($MONGO_DIR + "\" + $MONGO_LINK)
    $TARGET = ($MONGO_DIR + "\" + $VERSION)
    New-Item -ItemType SymbolicLink -Force -Path $PATH -Target $TARGET
    #New-Item -ItemType SymbolicLink -Force -Path  -Target ${$MONGO_DIR + "\" + $VERSION}
    mongo --version
}