# Configuração de Compartilhamento de Listas - NutriPlan

Este documento descreve as configurações necessárias para viabilizar o compartilhamento de listas de compras com extensão personalizada `.nutriplan` no aplicativo NutriPlan.

## 📱 Android

### 1. Arquivo de Permissões de Arquivo

**Localização:** `android/app/src/main/res/xml/file_paths.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-files-path name="external_files" path="." />
    <external-cache-path name="external_cache" path="." />
    <cache-path name="cache" path="." />
    <files-path name="files" path="." />
</paths>
```

**Propósito:** Define os caminhos de arquivo que o aplicativo pode acessar para compartilhamento e armazenamento temporário.

### 2. Configuração do AndroidManifest.xml

**Localização:** `android/app/src/main/AndroidManifest.xml`

**Adicionar dentro da tag `<activity>` da MainActivity:**

```xml
<!-- Intent filter para abrir arquivos .nutriplan -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="file" />
    <data android:mimeType="*/*" />
    <data android:pathPattern=".*\.nutriplan" />
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="content" />
    <data android:mimeType="application/x-nutriplan" />
</intent-filter>
```

**Funcionalidades:**
- **Primeiro intent-filter:** Permite que o app abra arquivos `.nutriplan` do sistema de arquivos
- **Segundo intent-filter:** Registra o tipo MIME personalizado `application/x-nutriplan`
- **Resultado:** Arquivos `.nutriplan` serão automaticamente associados ao NutriPlan

## 🍎 iOS

### Configuração do Info.plist

**Localização:** `ios/Runner/Info.plist`

**Adicionar antes da tag de fechamento `</dict>`:**

```xml
<key>CFBundleDocumentTypes</key>
<array>
    <dict>
        <key>CFBundleTypeName</key>
        <string>NutriPlan Shopping List</string>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>LSHandlerRank</key>
        <string>Owner</string>
        <key>LSItemContentTypes</key>
        <array>
            <string>com.nutriplan.shoppinglist</string>
        </array>
    </dict>
</array>
<key>UTExportedTypeDeclarations</key>
<array>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>com.nutriplan.shoppinglist</string>
        <key>UTTypeDescription</key>
        <string>NutriPlan Shopping List</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.data</string>
        </array>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>nutriplan</string>
            </array>
            <key>public.mime-type</key>
            <array>
                <string>application/x-nutriplan</string>
            </array>
        </dict>
    </dict>
</array>
```

**Componentes:**

1. **CFBundleDocumentTypes:** Registra o tipo de documento que o app pode abrir
   - `CFBundleTypeName`: Nome amigável do tipo de arquivo
   - `CFBundleTypeRole`: Define o app como "Editor" do tipo
   - `LSHandlerRank`: "Owner" indica que este app é o proprietário do tipo
   - `LSItemContentTypes`: Referencia o identificador do tipo personalizado

2. **UTExportedTypeDeclarations:** Declara um novo tipo de arquivo personalizado
   - `UTTypeIdentifier`: Identificador único do tipo (`com.nutriplan.shoppinglist`)
   - `UTTypeDescription`: Descrição do tipo de arquivo
   - `UTTypeConformsTo`: Indica que é um tipo de dados genérico
   - `UTTypeTagSpecification`: Especifica a extensão (`.nutriplan`) e tipo MIME

## 🔧 Dependências Necessárias

**Adicionar ao `pubspec.yaml`:**

```yaml
dependencies:
  share_plus: ^10.1.4      # Para compartilhamento de arquivos
  path_provider: ^2.1.4    # Para acesso ao sistema de arquivos
  file_picker: ^8.3.7      # Para seleção de arquivos
```

## 🚀 Como Funciona

### Fluxo de Compartilhamento:
1. Usuário seleciona "Compartilhar" no menu da lista
2. App serializa a lista em JSON
3. Arquivo `.nutriplan` é criado no diretório temporário
4. Sistema de compartilhamento nativo é acionado
5. Usuário pode compartilhar via WhatsApp, email, etc.

### Fluxo de Importação:
1. **Método 1:** Usuário toca em "Importar Lista" no app
2. **Método 2:** Usuário toca em arquivo `.nutriplan` no sistema
3. App abre automaticamente (devido às configurações)
4. Arquivo é lido e deserializado
5. Lista é importada e salva no Firestore

## ✅ Verificação da Configuração

### Android:
- [ ] Arquivo `file_paths.xml` criado
- [ ] Intent filters adicionados ao `AndroidManifest.xml`
- [ ] App reconhece arquivos `.nutriplan` quando tocados

### iOS:
- [ ] Configurações adicionadas ao `Info.plist`
- [ ] App aparece como opção para abrir arquivos `.nutriplan`
- [ ] Tipo de arquivo registrado no sistema

### Funcionalidade:
- [ ] Compartilhamento gera arquivo `.nutriplan`
- [ ] Importação funciona via seletor de arquivos
- [ ] Abertura automática funciona ao tocar em arquivos `.nutriplan`
- [ ] Dados são preservados corretamente na serialização/deserialização

## 🐛 Troubleshooting

### Problemas Comuns:

1. **Arquivo não abre automaticamente:**
   - Verificar se os intent filters estão corretos no Android
   - Verificar se o `Info.plist` foi atualizado no iOS
   - Reinstalar o app após as mudanças

2. **Erro ao compartilhar:**
   - Verificar permissões de arquivo
   - Verificar se as dependências foram instaladas (`flutter pub get`)
   - Verificar se o `file_paths.xml` existe

3. **Erro ao importar:**
   - Verificar se o arquivo está no formato JSON válido
   - Verificar se a estrutura de dados está correta
   - Verificar logs de erro no console

## 📝 Notas Importantes

- **Extensão personalizada:** `.nutriplan` é exclusiva do NutriPlan
- **Tipo MIME:** `application/x-nutriplan` é registrado em ambas as plataformas
- **Compatibilidade:** Funciona em Android 5.0+ e iOS 11.0+
- **Segurança:** Arquivos são validados antes da importação
- **Performance:** Arquivos são temporários e limpos automaticamente

---

**Última atualização:** Janeiro 2025
**Versão:** 1.0.0