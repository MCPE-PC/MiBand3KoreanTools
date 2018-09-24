#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

LONG_BIT=`getconf LONG_BIT`
JQ_VERSION="${1:-1.5}"

if [[ "$LONG_BIT" != '64' ]]; then
	LONG_BIT='32'
fi

(wget -q -O 'jq' "https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-linux$LONG_BIT" &&\
 chmod +x './jq') || exception 'jq(을)를 다운로드할 수 없습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] jq(을)를 다운로드하였습니다."
