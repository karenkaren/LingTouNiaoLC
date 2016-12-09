KEY = iPhone Distribution: Shanghai Wuyou Internet Financial Information Service Co.,Ltd. (XPECRFUB94)
KEY2 = iPhone Distribution: Shanghai Wuyou Internet Financial Information Service Co.,Ltd.
infoPath="./lingtouniao/Info.plist"

branchName=$(shell git branch|grep "*"|sed -n 's/* //p')
version=$(shell /usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" ${infoPath})
buildNumberInfo=$(shell git log -a |wc -l | sed 's/^[ \t]*//g')
buildNumber=$(shell git log -1 --pretty=format:%h)_$(shell git log -a |wc -l | sed 's/^[ \t]*//g')
serverEnvironment=BUILD_FOR_TEST
profileName=licai_enter2
signKey=$(KEY2)
configWay=Debug
configInfo=ADHOC=1
productName=lingtouniao
ipaName = $(productName)_$(branchName)_$(version)_$(buildNumber)_$(serverEnvironment)_$(configInfo)_$(profileName).ipa

UndoCommit=0
ifdef rename
    ifeq ($(rename),1)
    UndoCommit=1
	Cmd1=echo 'rename app name' & git cherry-pick b20db8309039b4769b
    else 
    endif
else
	Cmd1=echo 'do not rename app name'
endif

ifdef APNS
	profileName=MMBang_Adhoc5
	signKey=$(KEY)
endif


.PHONY: build test dev

all:
	make build

prerelease:
	make build serverEnvironment=BUILD_FOR_RELEASE configInfo=

dev:
	make build serverEnvironment=BUILD_FOR_DEVELOP

adhoc:
	make build serverEnvironment=BUILD_FOR_RELEASE 

release:
	make build serverEnvironment=BUILD_FOR_RELEASE  profileName=IOS_Distribution_01112 configWay=Release configInfo= signKey="$(KEY)"
	
test:
	make build serverEnvironment=BUILD_FOR_TEST

build:
	$(Cmd1)
	echo $(buildNumber)
	echo $(profileName)
	echo $(configWay)
	echo $(configInfo)

	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $(buildNumberInfo)" "$(infoPath)"

	xcodebuild -workspace $(productName).xcworkspace -scheme Pods -derivedDataPath build/DerivedData OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build -configuration $(configWay)
	xcodebuild -workspace $(productName).xcworkspace -scheme $(productName) -derivedDataPath build/DerivedData OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build -configuration $(configWay) clean build GCC_PREPROCESSOR_DEFINITIONS='$(GCC_PREPROCESSOR_DEFINITIONS) $(serverEnvironment) $(configInfo)'
	xcrun -sdk iphoneos PackageApplication build/$(configWay)-iphoneos/$(productName).app -o ~/Downloads/$(ipaName) --sign "$(signKey)" --embed ProvisionProfile/$(profileName).mobileprovision
	if [ $(UndoCommit) -eq 0 ]; then echo cleanup && git reset --hard ;else echo backtonormal && git reset --hard HEAD~1; fi;
	fir publish ~/Downloads/$(ipaName) -T b07d36110cca6eea341c861bc7a5dbd0
	cp -r build/$(configWay)-iphoneos/$(productName).app.dSYM ~/Downloads/$(ipaName).dSYM

sendmail:
	scripts/sendrelease.pl wupeijing@lingtouniao.com linyan@lingtouniao.com 

archive:
	xcodebuild -project $(productName).xcodeproj -scheme $(productName) -configuration "ADHOC" archive -archivePath ~/Desktop/$(productName).xcarchive

upload:
	rsync --progress -av ~/Downloads/Tour3D.ipa deploy@$(HOST):$(REMOTE)/
	ssh deploy@$(HOST) 'cd $(REMOTE) && sed -e "s/^Last.*/Last update: `date`<br\/>`du -sh Tour3D.ipa`/g" -i"" index.html'
	open http://$(HOST)/builds/ios/$(APP)/
