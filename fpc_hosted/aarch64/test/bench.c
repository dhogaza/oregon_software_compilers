unsigned int *colnums;
double *val;

struct foostruct
{
  unsigned int rows;
  unsigned int *colnums;
  unsigned int *rowstart;
};

struct foostruct *cols;

void
foo (double *dst, const double *src)
{
  const unsigned int n_rows = cols->rows;
  const double *val_ptr = &val[cols->rowstart[0]];
  const unsigned int *colnum_ptr = &cols->colnums[cols->rowstart[0]];  

  double *dst_ptr = dst;
  for (unsigned int row=0; row<n_rows; ++row)
    {
      double s = 0.;
      const double *const val_end_of_row = &val[cols->rowstart[row+1]];
      while (val_ptr != val_end_of_row)
        s += *val_ptr++ * src[*colnum_ptr++];
      *dst_ptr++ = s;
    }
}

