#!/usr/bin/env bash

cd -P `dirname "${BASH_SOURCE[0]}"`
FILENAME=`basename "$0"`
function exception {
	echo "[$FILENAME] 진행 중에 실패하여 종료합니다."
	echo '버그라고 생각될 경우 터미널 스크린샷과 함께 GitHub에서 이슈를 생성하세요.'
	exit 1
}

DEPENDENCIES=('curl' 'java' 'wget')
NOT_INSTALLED=()
for DEPENDENCY in "${DEPENDENCIES[@]}"; do
	type "$DEPENDENCY" > /dev/null || NOT_INSTALLED=("${NOT_INSTALLED[@]}" "$DEPENDENCY")
done
if [[ ${#NOT_INSTALLED[@]} -gt 0 ]]; then
	for DEPENDENCY in "${NOT_INSTALLED[@]}"; do
		echo "$DEPENDENCY(을)를 설치해주세요." > MiBand3Tools.log && cat MiBand3Tools.log && cat MiBand3Tools.log >> MiBand3Tools.tmp.log && rm MiBand3Tools.log
	done
	exception
fi

(./init.sh &&\
 ./get_apktool.sh &&\
 ./get_pup.sh &&\
 ./get_mi_fit.sh $1 &&\
 ./rebuild_mi_fit.sh &&\
 ./sign_mi_fit.sh $2 &&\
 ./finish.sh) || exception

mv MiBand3Tools.tmp.log MiBand3Tools.log

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] 모든 과정을 성공하였습니다. 결과물은 dist 디렉터리에 있습니다."
