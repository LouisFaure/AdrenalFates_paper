from pandas.errors import EmptyDataError
from glob import glob 
import pandas as pd
from scFates.tools.utils import ProgressParallel
from joblib import delayed
import scanpy as sc
from scipy.sparse import csr_matrix

def load_Fc(p):
    try:
        df = pd.read_csv(p, sep='\t', comment='#',usecols=[0,6],index_col=0)
        cellid=p.split(".")[0].split("_")
        df.columns=["_".join([cellid[i] for i in range(3)])+":"+cellid[3]]
        return df
    except EmptyDataError:
        pass
    
fcs=ProgressParallel(n_jobs=40,total=len(glob("*.txt")))(delayed(load_Fc)(p) for p in glob("*.txt"))

allcounts=pd.concat(fcs,axis=1)
adata=sc.AnnData(allcounts.T)
adata.X=csr_matrix(adata.X)

adata.write_h5ad("adata_raw.h5ad")
