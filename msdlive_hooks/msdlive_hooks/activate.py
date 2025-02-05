import os
import shutil


def activate(server_app=None):
    """
    From inside the user's home directory:
    1. Checks if a symlink named 'data' exists:
       - If it exists, removes the symlink and prints a message.
       - If it does not exist, prints a message indicating that it is not a symlink.
    3. Defines a function `copy_function` to copy files from source to destination if the destination
       does not exist or if the source file is newer than the destination file.
    4. Copies everything from '/data' to '/basex/data/'.
    """
    server_app.log.info(f"Plugin has been activated! server_app {server_app}")
    
    symlink_path = 'data'
    if os.path.islink(symlink_path):
        os.unlink(symlink_path)
        server_app.log.info(f"Symlink '{symlink_path}' has been removed.")
    else:
        server_app.log.info(f"'{symlink_path}' is not a symlink.")
    
    
    # Recursively copy everything from '/data' to /basex/data/
    source_path = '/data/basexdb' #/data will be read only
    dest_path = "/basex/data"
    
    if not os.path.exists(source_path):
        server_app.log.error(f"Source directory '{source_path}' does not exist.")
        return
    
    # there is some metadata file that is causing this error to be thrown when shutil.copytree 
    # on the source and dest directly, no error is thrown when using the code below that copies
    # individually. This might be an issue only when running the container locally but leaving this
    # code in place since the error was red herion and files were still copied fine but seeing the error
    # logged results in dev waisting time trying to figure out what is wrong.
    try:
        server_app.log.info(f"Copying basex data...")
        for item in os.listdir(source_path):
            s = os.path.join(source_path, item)
            d = os.path.join(dest_path, item)
            try:
                if os.path.isdir(s):
                    shutil.copytree(s, d, dirs_exist_ok=True)
                else:
                    shutil.copy2(s, d)
            except PermissionError as e:
                server_app.log.error(f"Permission error while copying {s} to {d}: {e}")
            except Exception as e:
                server_app.log.error(f"Error while copying {s} to {d}: {e}")
        server_app.log.info(f"Files copied successfully from {source_path} to {dest_path}")
    except Exception as e:
        server_app.log.error(f"Failed to copy files from {source_path} to {dest_path}: {e}")