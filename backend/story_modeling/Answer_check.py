import konlpy
from konlpy.tag import Okt

def check_answers(child_anws, tale):
    print('check_answers connect')
    # 이야기 선택 0. 우리끼리 가자 1. 내 꿈은 무슨 색일까
    if tale == 0:
        tale = [
            {
                'key1': ['겨울']
            },
            {
                'key1': ['곰', '아기곰']
            },
            {
                'key1': ['너구리', '아기너구리']
            },
            {
                'key1': ['뿔']
            },
            {
                'key1': ['이야기', '얘기', '옛날이야기', '옛이야기']
            }
        ]
    elif tale == 1:
        tale = [
            {
                'key1': ['빨간색', '빨강', '빨강색', '붉은색','적색', '홍색']
            },
            {
                'key1': ['분홍', '분홍색', '핑크', '핑크색']
            },
            {
                'key1': ['오색', '색동', '색동옷', '저고리']
            },
            {
                'key1': ['색', '색깔', '색상', '빛깔', '빛', '컬러'],
                'key2': ['섞다'],
                'key3': ['이상하다']
            },
            {
                'key1': ['행복', '행복하다']
            }
        ]

    okt = Okt()
    tokenized_child_anws = {}

    for idx, anw in enumerate(child_anws):
        tokens = okt.pos(anw, norm=True, stem=True)
        tokens = [word for word, pos in tokens]
        key = f'anw{idx + 1}'
        tokenized_child_anws[key] = tokens

    def keywords_checker(keywords_dict, tokenized_kid_answer):
        for key, keywords in keywords_dict.items():
            if not any(keyword in tokenized_kid_answer for keyword in keywords):
                return False
        return True

    results = []

    for idx, q in enumerate(tale):
        anw_key = f'anw{idx + 1}'
        result = keywords_checker(q, tokenized_child_anws[anw_key])

        if result:
            results.append(True)
        else:
            results.append(False)
    print(result)
    return results

# 아동 답변

if __name__ == '__main__':
    check_answers()


