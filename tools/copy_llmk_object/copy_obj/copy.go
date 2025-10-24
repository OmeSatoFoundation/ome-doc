package copy_obj

import (
	"errors"
	"io"
	"io/fs"
	"os"
	"path"
)

func getFileMode(f *os.File) (os.FileMode, error) {
	stat, err := f.Stat()
	if err != nil {
		return os.FileMode(0), err
	}
	return stat.Mode(), nil
}

func Copy(sources []string, destDir string) error {
	for _, src := range sources {
		fin, err := os.Open(src)
		if err != nil {
			if errors.Is(err, fs.ErrNotExist) {
				continue
			}
			return err
		}
		defer fin.Close()
		dest := path.Join(destDir, path.Base(src))
		mode, err := getFileMode(fin)
		if err != nil {
			return err
		}
		fout, err := os.OpenFile(dest, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, mode)
		if err != nil {
			return err
		}
		defer fout.Close()
		_, err = io.Copy(fout, fin)
	}
	return nil
}
