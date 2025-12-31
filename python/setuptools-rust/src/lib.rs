use pyo3::prelude::*;

#[pyfunction]
fn hello() -> PyResult<String> {
    Ok("Hello from Rust!".to_string())
}

#[pymodule]
fn _lib(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hello, m)?)?;
    Ok(())
}