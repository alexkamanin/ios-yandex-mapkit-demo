PROJECT_NAME = MapKitDemoGenerated
PROJECT_EXTENSION = .xcodeproj

generate: check
	./BuildTools/Binaries/XcodeGen/bin/xcodegen generate --spec ./project.yml

check:
	sh checkDepsExists.sh

open:
	open $(PROJECT_NAME)$(PROJECT_EXTENSION)

distclean: clean
	rm -rf ~/Library/Developer/Xcode/DerivedData/$(PROJECT_NAME)-*

clean:
	rm -rfv $(PROJECT_NAME)$(PROJECT_EXTENSION)
	rm -rfv Frameworks/*.xcframework
	find . -path '*/Generated/.*' -prune -o -path '*/Generated/*' -print -delete