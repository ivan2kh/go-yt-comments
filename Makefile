BRANCH = "master"
GO_BUILDER_IMAGE = "vidsyhq/go-builder"
PATH_BASE = "/go/src/github.com/ivan2kh"
REPONAME = "go-yt-comments"
TEST_PACKAGES = "./ytc"
VERSION = $(shell cat ./VERSION)

check-version:
	@echo "=> Checking if VERSION exists as Git tag..."
	(! git rev-list ${VERSION})

install-ci:
	@docker run \
	-e BUILD=false \
	-v "${CURDIR}":${PATH_BASE}/${REPONAME} \
	-w ${PATH_BASE}/${REPONAME} \
	${GO_BUILDER_IMAGE}

push-tag:
	git checkout ${BRANCH}
	git pull origin ${BRANCH}
	git tag ${VERSION}
	git push origin ${BRANCH} --tags

test:
	@API_KEY=${API_KEY} go test "${TEST_PACKAGES}" -cover

test-ci:
	@docker run \
	-e API_KEY=${API_KEY} \
	-v "${CURDIR}":${PATH_BASE}/${REPONAME} \
	-w ${PATH_BASE}/${REPONAME} \
	--entrypoint=go \
	${GO_BUILDER_IMAGE} test "${TEST_PACKAGES}" -cover
