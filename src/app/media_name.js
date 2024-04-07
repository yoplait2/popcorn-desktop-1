((App) => {
    const mediaNameSymbol = Symbol('torrentMediaName');
    const maxTimeInCacheMs = 60 * 1000;

    class MediaNamePlugin {
        constructor() {
            this._infoHashToMediaName = new Map();
            this._infoHashToInsertTime = new Map();
            this._cleanupTask = setInterval(() => this._clean(), maxTimeInCacheMs);
        }

        _remove(infoHash) {
            this._infoHashToInsertTime.delete(infoHash);
            this._infoHashToMediaName.delete(infoHash);
        }

        _clean() {
            const now = Date.now();
            for (const [infoHash, insertTime] of this._infoHashToInsertTime) {
                if (now - insertTime >= maxTimeInCacheMs) {
                    this._remove(infoHash);
                }
            }
        }

        _consumeMediaName(infoHash) {
            const mediaName = this._infoHashToMediaName.get(infoHash);
            this._remove(infoHash);
            return mediaName;
        }

        setMediaName(infoHash, mediaName) {
            this._infoHashToMediaName.set(infoHash, mediaName);
            this._infoHashToInsertTime.set(infoHash, Date.now());
        }

        getMediaName(torrent) {
            if (torrent.name) {
                return torrent.name;
            }
            if (torrent[mediaNameSymbol]) {
                return torrent[mediaNameSymbol];
            }
            const mediaName = this._consumeMediaName(torrent.infoHash);
            if (mediaName) {
                torrent[mediaNameSymbol] = mediaName;
                return mediaName;
            }
            return i18n.__('Unknown torrent');
        }
    }
    App.plugins.mediaName = new MediaNamePlugin();
})(window.App);
