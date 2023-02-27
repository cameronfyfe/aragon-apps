apps := \
agent \
finance \
minime-factory \
token-manager \
voting

contracts-init := $(addsuffix .contracts.init, ${apps})
contracts-build := $(addsuffix .contracts.build, ${apps})
ui-init := $(addsuffix .ui.init, ${apps})
ui-build := $(addsuffix .ui.build, ${apps})
all := $(addsuffix .all, ${apps})
start := $(addsuffix .start, ${apps})
clean := $(addsuffix .clean, ${apps})

.PHONY: \
${contracts-init} \
${contracts-build} \
${ui-init} \
${ui-build} \
${all} \
${start} \
${clean} \
init build all \
clean \
list-apps \
ci

init: ${contracts-init} ${ui-init}
build: ${contracts-build} ${ui-build}
all: ${all}
clean: ${clean}
ci: all

# node_modules for workspace (root config and solidity contracts)
wsNodeModules := node_modules $(patsubst %, apps/%/node_modules, ${apps})
wsPkgJsons := package.json $(patsubst %, apps/%/package.json, ${apps})
${wsNodeModules}: ${wsPkgJsons} yarn.lock
	yarn install
	@mkdir -p $@ || (rm $@ && mkdir $@)
	@touch $@

# node_modules for frontend apps (individiual projects not part of workspace)
uiNodeModules := $(patsubst %, apps/%/app/node_modules, ${apps})
${uiNodeModules}: apps/%/app/node_modules: apps/%/app/package.json apps/%/app/yarn.lock
	cd apps/$*/app && yarn install
	@touch $@

${contracts-init}: %.contracts.init: ${wsNodeModules}

${contracts-build}: %.contracts.build: %.contracts.init
	cd apps/$* && yarn compile

${ui-init}: %.ui.init: apps/%/app/node_modules

${ui-build}: %.ui.build: %.ui.init
	cd apps/$*/app && yarn build

${all}: %.all:
	@$(MAKE) $*.contracts.build
	@if [[ "$*" != "minime-factory" ]]; then \
		$(MAKE) $*.ui.build; \
	fi

${start}: %.start: %.contracts.init %.ui.init
	cd apps/$* && yarn buidler start

${clean}: %.clean:
	rm -rf node_modules ${appNodeModules}
	cd apps/$* && rm -rf _env artifacts cache dist app/node_modules

list-apps:
	@echo ${apps}
