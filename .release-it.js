module.exports = {
  git: {
    requireBranch: "main",
    commitMessage: "chore(release): v${version}",
    tagAnnotation: "v${version}",
    tagName: "v${version}",
  },

  github: { release: true },
  npm: { publish: false },

  plugins: {
    "@release-it/conventional-changelog": {
      infile: "CHANGELOG.md",
      header: "# Changelog",
      preset: {
        name: "conventionalcommits",
        types: [
          { type: "feat", section: "Features" },
          { type: "fix", section: "Bug Fixes" },
          { type: "refactor", section: "Refactoring" },
        ],
      },
    },
  },
};
