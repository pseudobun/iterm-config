set -x NVM_DIR ~/.nvm
function nvm
   bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end