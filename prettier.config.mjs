import kit from '@aimuzov-projects/infra-site-kit/prettier'

export default {
	...kit,
	overrides: [
		...kit.overrides,
		// Примеры в доках показывают конфиги как их вставлять, с отступами пробелами.
		{ files: '*.md', options: { embeddedLanguageFormatting: 'off' } },
	],
}
