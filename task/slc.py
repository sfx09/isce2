import asf_search as asf

with open('artifacts/slc/SLC.txt', 'r') as f:
    slc_files = f.read().replace('\n', '').split(',')

slc_files = list(filter(lambda x: x, slc_files))
slc_data = asf.product_search(slc_files[-2:])

slc_data.download("artifacts/slc", processes=8)
