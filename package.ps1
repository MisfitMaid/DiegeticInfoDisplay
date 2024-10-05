$7z = "C:\Program Files\7-Zip\7z"
if (test-path DID.op) { rm DID.op -verbose }
& $7z a -tzip DID.op *.as info.toml *.json LICENSE
