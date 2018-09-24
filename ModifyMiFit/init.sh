#!/usr/bin/env bash

# 작업을 수행하기 전에 이 스크립트를 첫번째로 실행하십시오.

# 운영체제가 호환되는지 확인합니다.
if [[ `uname -o` != 'GNU/Linux' ]]; then
	echo 'Linux에서만 실행할 수 있습니다.'
	exit 1
fi

FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

# 이 도구 모음에 대해 안내합니다.
echo '이 도구 모음은~~~ 아 몰라' > /dev/null

# job 디렉터리를 초기화합니다.
if [ -d 'job' ]; then
	NEW_DIRNAME="job.old_$RANDOM-$RANDOM"
	echo "기존에 있던 job 디렉터리를 $NEW_DIRNAME(으)로 이동합니다."
	mv 'job' "$NEW_DIRNAME"
fi
mkdir 'job' || exception 'job 디렉토리 생성을 실패하였습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] job 디렉터리를 초기화하였습니다."
