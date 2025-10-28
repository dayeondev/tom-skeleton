# TOM Skeleton

Tomorrow Of Me - NCP 테스트용 깡통 프로젝트

## 개요

NCP (Naver Cloud Platform) Container Registry 테스트용 최소한의 Next.js 프로젝트입니다.

## 기능

- "tom" 메시지를 표시하는 간단한 페이지
- Docker 이미지 빌드 및 푸시
- NCP Container Registry 연동

## 실행 방법

### 로컬 개발

```bash
# 의존성 설치
npm install

# 개발 서버 실행
npm run dev

# 빌드
npm run build

# 프로덕션 실행
npm start
```

### Docker 실행

```bash
# 이미지 빌드
docker build -t tom-skeleton .

# 컨테이너 실행
docker run -p 3000:3000 tom-skeleton
```

## 구조

```
tom-skeleton/
├── src/
│   └── app/
│       ├── page.tsx      # 메인 페이지 ("tom" 표시)
│       ├── layout.tsx    # 레이아웃
│       └── globals.css   # 전역 스타일
├── Dockerfile            # Docker 빌드 설정
├── buildspec.yml         # NCP CodeBuild 설정
├── package.json          # 의존성 및 스크립트
├── next.config.js        # Next.js 설정
└── tsconfig.json         # TypeScript 설정
```

## 환경 변수

- `NEXT_PUBLIC_API_BASE_URL`: API 기본 URL
- `NEXT_PUBLIC_API_CAREER_URL`: Career 서비스 URL