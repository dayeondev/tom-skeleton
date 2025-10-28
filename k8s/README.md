# TOM Skeleton Kubernetes 배포

## 구조

```
k8s/
├── deployment.yaml      # 애플리케이션 배포 설정
├── service.yaml         # 서비스 (ClusterIP)
├── ingress.yaml         # Ingress (선택적)
├── configmap.yaml       # 환경 변수 설정
├── secret.yaml          # NCP 레지스트리 인증 정보
├── kustomization.yaml   # Kustomize 설정
└── README.md           # 이 파일
```

## 배포 전 준비

### 1. NCP Container Registry Secret 생성

```bash
# 실제 NCP 계정 정보로 Secret 생성
kubectl create secret docker-registry ncr-registry-secret \
  --docker-server=ncr.kpaas.taobao.com:5000 \
  --docker-username=YOUR_NCP_USERNAME \
  --docker-password=YOUR_NCP_PASSWORD \
  --docker-email=YOUR_EMAIL
```

### 2. ConfigMap 환경 설정

`configmap.yaml`에서 실제 환경에 맞게 API URL 수정:

```yaml
data:
  NEXT_PUBLIC_API_BASE_URL: "http://your-api-server:8080"
  NEXT_PUBLIC_API_CAREER_URL: "http://your-career-server:8000"
```

## 배포 방법

### 방법 1: Kustomize 사용 (추천)

```bash
# kustomization.yaml을 사용한 배포
kubectl apply -k k8s/

# 상태 확인
kubectl get pods -l app=tom-skeleton
kubectl get services -l app=tom-skeleton
```

### 방법 2: 개별 파일 배포

```bash
# 순서대로 배포
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Ingress 사용 시
kubectl apply -f k8s/ingress.yaml
```

## 포트 포워딩 (로컬 테스트)

```bash
# Service로 포트 포워딩
kubectl port-forward service/tom-skeleton-service 3001:80

# Pod로 직접 포트 포워딩
kubectl port-forward deployment/tom-skeleton 3001:3000
```

## 로그 확인

```bash
# Pod 로그 확인
kubectl logs -l app=tom-skeleton -f

# 특정 Pod 로그
kubectl logs -f deployment/tom-skeleton
```

## 스케일링

```bash
# 레플리카 수 조정
kubectl scale deployment tom-skeleton --replicas=3

# Kustomize로 스케일링 (kustomization.yaml 수정)
replicas:
- name: tom-skeleton
  count: 3
```

## 업데이트

```bash
# 이미지 태그 업데이트
kubectl set image deployment/tom-skeleton tom-skeleton=tom-reg.kr.ncr.ntruss.com/tom-skeleton:v1.1.0

# ConfigMap 업데이트
kubectl apply -f k8s/configmap.yaml

# 재시작
kubectl rollout restart deployment/tom-skeleton
```

## 삭제

```bash
# Kustomize로 전체 삭제
kubectl delete -k k8s/

# 개별 삭제
kubectl delete -f k8s/
```

## 주의사항

1. **Ingress**: Ingress Controller가 설치된 경우에만 `ingress.yaml` 적용
2. **Secret**: `secret.yaml`의 `.dockerconfigjson`은 예시 값이며, 실제 NCP 계정 정보로 교체 필요
3. **환경 변수**: `configmap.yaml`의 API URL을 실제 환경에 맞게 수정
4. **이미지 태그**: `kustomization.yaml`의 이미지 태그를 실제 빌드된 버전으로 수정

## 환경별 배포

```bash
# 개발 환경
kubectl apply -k overlays/dev

# 운영 환경
kubectl apply -k overlays/prod
```