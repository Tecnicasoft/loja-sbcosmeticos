# 🎯 Como Usar o Template Petshop

## Checklist Rápido para Novo Cliente

### ✅ Setup Inicial
- [ ] Copiar pasta `petshop-template/` para `projeto-cliente-nome/`
- [ ] `cd projeto-cliente-nome/`  
- [ ] `git init` (inicializar Git limpo)
- [ ] `flutter pub get` (baixar dependências)

### ✅ Personalização
- [ ] **pubspec.yaml:** Alterar `name: petshop_template` → `name: projeto_cliente`
- [ ] **Imports:** Substituir `petshop_template` por `projeto_cliente` nos .dart
- [ ] **Cores:** Editar `lib/src/config/custom_colors.dart`
- [ ] **Assets:** Trocar logos em `assets/images/`

### ✅ Plataformas Mobile
- [ ] `flutter create --platforms=android,ios .` (gerar pastas limpas)
- [ ] **Android:** Configurar `android/app/build.gradle` (applicationId, signing)
- [ ] **iOS:** Configurar `ios/Runner/Info.plist` (bundle identifier)

### ✅ Deploy
- [ ] **Android:** Gerar keystore único do cliente
- [ ] **iOS:** Configurar provisioning profiles
- [ ] **Git:** `git remote add origin [repo-cliente]`
- [ ] **First commit:** `git add . && git commit -m "Setup inicial cliente"`

---

**🚀 Pronto para desenvolvimento!**