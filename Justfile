just := 'just --justfile ' + justfile() + ' --working-directory .'
node16 := just + ' __node16'
node12 := just + ' __node12'

hardhat := 'yarn hardhat --config ./hardhat.config.js'

NETWORK := env_var('NETWORK')

default:
    just --list

init-repo:
    {{node16}} yarn install

set-arapp APP ENS_ADDRESS:
    jq \
      '.environments.{{NETWORK}} |= \
        { \
          "registry": "{{ENS_ADDRESS}}", \
          "appName": "{{APP}}.aragonpm.eth", \
          "network": "{{NETWORK}}" \
        }' \
      apps/{{APP}}/arapp.json \
      > tmp.json
    cp tmp.json apps/{{APP}}/arapp.json
    rm tmp.json

build-app APP:
    cd apps/{{APP}} && {{node16}} yarn install
    cd apps/{{APP}} && {{node16}} yarn compile

build-app-ui APP:
    cd apps/{{APP}} && {{node16}} yarn build

publish-app APP +FLAGS='':
    cd apps/{{APP}} && {{node16}} {{hardhat}} publish major {{FLAGS}} --network {{NETWORK}}
    mkdir -p _env
    cp apps/{{APP}}/_env/.env* _env/

__node16 +CMD:
    nix develop .#node16 --command bash -c '{{CMD}}'

__node12 +CMD:
    nix develop .#node12 --command bash -c '{{CMD}}'
